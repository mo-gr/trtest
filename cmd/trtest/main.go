package main

import (
	"flag"

	"github.com/aryszka/trtest"
)

var (
	version      string
	commit       string
	date         string
	printVersion bool
)

func init() {
	flag.BoolVar(&printVersion, "version", false, "print trtest version")
	flag.Parse()
}

func versionString() string {
	return fmt.Sprintf(
		"trtest version %s (commit: %s, build time: %s)",
		version, commit, date,
	)
}

func main() {
	if printVersion {
		println(versionString())
		return
	}

	println(trtest.Hello())
}
