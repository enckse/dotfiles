local utils = require("modules.utils")
return {
    request = function(args)
        if args == nil or args.url == nil or args.module.hash == nil or args.module == nil or args.system == nil then
            error("invalid request arguments")
        end
        local file = args.system.file_archive(args.module)
        local file_type = (function()
            if args.module.extension == ".tar.gz" or args.module.extension == ".tar.xz" then
                return "compressed data"
            end
            return nil
        end)()
        if file_type == nil then
            error(string.format("unable to detect file type: %s (%s)", file_type, args.module.extension))
        end
        local check_file = function()
            if not args.system.execute(string.format("file '%s' | grep -q '%s'", file, file_type)) then
                utils.log(string.format("invalid file type: %s", file))
                return false
            end
            local hash_command = string.format("sha256sum '%s' | cut -c 1-7", file)
            local use_hash = args.module.hash["source"]
            if use_hash == nil then
                use_hash = args.module.hash[args.system.os_identifier]
            end
            if not args.system.execute(string.format("%s | grep -q '^%s$'", hash_command, use_hash)) then
                os.execute(string.format("%s | sed 's/^/  -> have hash: /g'", hash_command))
                os.execute(string.format("echo '  -> want hash: %s'", use_hash))
                utils.log(string.format("invalid hash: %s", file))
                return false
            end
            return true
        end
        if args.system.execute(string.format("test -e '%s'", file)) then
            if check_file() then
                return
            end
        end
        utils.log(string.format("downloading: %s", args.url))
        if not args.system.execute(string.format("curl --silent -L '%s' > '%s'", args.url, file)) then
            error(string.format("failed to download: %s", args.url))
        end
        if not check_file() then
            error("invalid file")
        end
    end
}
