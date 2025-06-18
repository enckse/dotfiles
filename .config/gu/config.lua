return {
	goflags = "-trimpath -buildmode=pie -mod=readonly -modcacherw -buildvcs=false",
	target = "target",
	ldflags = os.getenv("LDFLAGS"),
	env_filter = "~/",
}
