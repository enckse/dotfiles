#!/bin/sh -e
GOTOOLS="
git.sr.ht/~enckse/git-tools/cmd/...
git.sr.ht/~enckse/lockbox/cmd/lb
github.com/mgechev/revive 
golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment
golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize
honnef.co/go/tools/cmd/staticcheck
mvdan.cc/gofumpt
golang.org/x/tools/gopls
github.com/restic/restic/cmd/restic
filippo.io/age/cmd/...
"
GOMODS="$PKGS_BIN/go-mod-updates"
{
  echo "#!/bin/sh -e"
  echo "go get -u ./..."
  echo "go mod tidy"
} > "$GOMODS"
chmod 755 "$GOMODS"

_pkgv() {
  echo "check_version 'https://$1'" >> "$PKGS_LIST"
}

for f in $GOTOOLS; do
  versioning=""
  case "$f" in
    git.sr.ht/* | github.com/*)
      _pkgv "$(echo "$f" | cut -d "/" -f 1,2,3)"
      case "$f" in
        *enckse/git-tools*)
          versioning="v0.3.0"
          ;;
        *enckse/lockbox*)
          versioning="v1.4.5"
          ;;
        *mgechev/revive*)
          versioning="v1.9.0"
          ;;
        *restic/restic*)
          versioning="v0.18.0"
          ;;
      esac
      ;; 
    */fieldalignment)
      versioning=latest
      ;;
    */age/cmd*)
      _pkgv "github.com/FiloSottile/age"
      versioning="v1.2.1"
      ;;
    */cmd/staticcheck)
      _pkgv "github.com/dominikh/go-tools"
      versioning="v0.6.1"
      ;;
    */modernize | */tools/gopls)
      _pkgv "github.com/golang/tools" 
      versioning="v0.18.1"
      ;;
    */gofumpt)
      _pkgv "github.com/mvdan/gofumpt"
      versioning="v0.8.0"
      ;;
    *)
      echo "unable to package version: $f" >&2
      exit 1
      ;;
  esac
  [ -z "$versioning" ] && echo "no version set: $f" && exit 1
  (cd "$PKGS_BIN" && GOBIN="$PWD" ./go install "$f@$versioning")
done
(cd "$PKGS_BIN" && SHELL="$USE_SHELL" ./lb completions > "$PKGS_COMP/lb")

GOLINT="$PKGS_BIN/go-lint"
{
  echo "#!/bin/sh -e"
  for f in $GOTOOLS; do
    FILES="./..."
    ARGS=""
    NAMED=$(basename "$f")
    case "$NAMED" in
      "gofumpt")
        ARGS="-d -extra"
        FILES='$(find . -type f -name "*.go" | tr "\\n" " ")'
        ;;
      "staticcheck")
        ARGS="-checks all -debug.run-quickfix-analyzers"
        ;;
      "modernize")
        ARGS="-test"
        ;;
      "revive" | "fieldalignment")
        ;;
      *)
        continue
        ;;
    esac
    echo "$NAMED $ARGS $FILES"
  done
  echo "go vet ./..."
} > "$GOLINT"
chmod 755 "$GOLINT"
