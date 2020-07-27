package main

import (
	"gerrit.o-ran-sc.org/r/scp/ric-app/kpimon/control"
)

func main() {
	c := control.NewControl()
	c.Run()
}

