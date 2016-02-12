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
	AAA string
	BBB string
	CCC int
}

func main() {
	slob.SetGenParams("slob_gen", "", "", "go")
	obj := new(ADCF)

	slob.Render("tpl/services.tpl").Read(obj).
		Execute()

}

// package main

// import (
// 	"fmt"
// 	"slob"
// )

// type Latlng struct {
// 	Lat float32
// 	Lng float32
// }

// func (latlng Latlng) String() string {
// 	return fmt.Sprintf("%g/%g", latlng.Lat, latlng.Lng)
// }

// func main() {
// 	data := make([]map[string]interface{}, 0)
// 	data = append(data, map[string]interface{}{"name": "dotcoo1", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.1, 135.1}})
// 	data = append(data, map[string]interface{}{"name": "dotcoo2", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.2, 135.2}})
// 	data = append(data, map[string]interface{}{"name": "dotcoo2", "url": "http://www.dotcoo.com/", "latlng": Latlng{24.3, 135.3}})

// 	slob.Render("tpl/test.tpl").Set("data", data).Execute()
// }
