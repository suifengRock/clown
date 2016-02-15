package main

import "slob"

type Struct struct {
	Name   string
	Fields []*Field
}

type Field struct {
	Name string
	Type string
}

type ADCF struct {
	AAA      string
	BBB      string
	CCC      int
	CreateAt int
	UpdateAt int
	DeleteAt int
}

func main() {
	slob.SetGenParams("slob_gen", "", "", "go")
	obj := new(ADCF)

	slob.Render("tpl/services.tpl").Read(obj).Set("pkgName", "test").
		Execute()

}
