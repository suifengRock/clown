{{range .data}}
name:{{.name}}, url:{{.url}}, latlng:{{.latlng}} lat:{{.latlng.Lat}} lng:{{.latlng.Lng}}
{{end}}