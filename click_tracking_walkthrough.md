### Wakthrough - Nasa example
1. Someone makes a search on Nasa.gov
 - They get brought to https://nasasearch.nasa.gov/search?query=pluto&affiliate=nasa&utf8=%E2%9C%93
 - [ResultsHelper#link_to_result_title](https://github.com/GSA/search-gov/blob/master/app/helpers/results_helper.rb#L13) adds some data attributes to a #search element and data-click attributes to each link.
 - Search results page has the below html.
```
<div data-a="nasa" data-l="en" data-q="pluto" data-t="1588714504" data-v="i14y" id="search">
...
<h4 class="title"><a data-click="{"i":103489,"p"1,"s":"BOOS"}" href="https://www.nasa.gov/mission_pages/newhorizons/main/index.html"><strong>Pluto</strong> | New Horizons</a></h4>
```

2. A link gets clicked
 - [click.js.coffee](https://github.com/GSA/search-gov/blob/master/app/assets/javascripts/searches/click.js.coffee) turns all those added data attributes into the below url. It does an async GET request before bringing the user to the url in the clicked on link.
 - `https://nasasearch.nasa.gov/clicked?v=i14y&t=1588714504&q=pluto&l=en&a=nasa&u=https%3A%2F%2Fwww.nasa.gov%2Fmission_pages%2Fnewhorizons%2Fmain%2Findex.html&i=103489&p=1&s=BOOS`
 - [Clicked#index](https://github.com/GSA/search-gov/blob/master/app/controllers/clicked_controller.rb) takes a bunch of parameters and makes the expected log line.
 - Logstash then sees that and imports it into elastic search.

3. The admin page then makes a request for clicks from elasticsearch.


### Other notes
- If it's an image it only has position added? `data-click="{"p":11}"`
- Images have [clk.js](https://github.com/GSA/search-gov/blob/master/app/assets/javascripts/searches/clk.js) involved somehow.
