## Design thoughts

First draft and easiest - They POST the clicks themselves based off our documentation.

Second draft - we give an implementation example, based of our search page html and js.

Third draft - We give them some js to include in their page. If they have a #search-results and individual .search-result, then we will fill out the data for them?

Or they include some javascript we've 
written on their page somewhere.


`<script type="javascript" src-"search.gov/clicktracking.js"></script>`

A modified version http://localhost:3000/assets/searches/click.js which is what the coffee script produces.
`(function(){var a;a=function(a){var c,t;return a.stopPropagation(),c=$(a.currentTarget),t=$.extend({},$("#search").data(),{u:this.href},c.data("click")),jQuery.ajax("/clicked",{async:!1,data:t})},$(document).on("click","#search a[data-click]",a)}).call(this);` 
