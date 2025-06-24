TAR  :=
URL  :=
HASH :=
TEST :=
SUM  :=
BIN  :=
NAME :=

.PHONY: unpack

unpack:
	@echo "getting: $(NAME)"
	@test -e $(TAR) || curl -L "$(URL)" > "$(TAR)"
	@echo "$(HASH)  $(TAR)" > $(SUM)
	@sha256sum --status -c $(SUM)
	@test $(TEST) || $(MAKE_CMD) _unpack

_unpack:
	@rm -rf "$(BIN)"
	@mkdir -p $(BIN)
	@tar xf $(TAR) --strip-component=1 -C $(BIN)
