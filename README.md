# backbone-nav-dropdown

Dropdown navigation module (on Backbone.View)

---
## Demo
- http://seckie.github.io/backbone-nav-dropdown/demo/
- http://seckie.github.io/backbone-nav-dropdown/demo/demo2.html

---
## Usage

Load jquery.js, underscore.js, backbone.js and this script

```
<script src="jquery.js"></script>
<script src="underscore.js"></script>
<script src="backbone.js"></script>
<script src="nav-dropdown.js"></script>
```

Instantiate $.NavDropdown object with some [options](#options).  
You must pass each nav item element to "el" option on Backbone.js rule.

```
<script>
var nav = new $.NavDropdown({
  el: '.nav-dropdown>ul>li',
  transitionDuration: 250,
  child: 'ul'
});
</script>
```

### Options

<table border="1">
<thead>
<tr>
<th>option name</th>
<th>default value</th>
<th>data type</th>
<th>description</th>
</tr>
</thead>
<tbody>
<tr>
<td>transitionDuration</td>
<td>250</td>
<td>Number</td>
<td>Duration of animation</td>
</tr>
<tr>
<td>child</td>
<td>'ul'</td>
<td>String</td>
<td>Selector that specifies child navigation. If sub nav aren't descendent of main nav, set <b>'null'</b> to this option.</td>
</tr>
<tr>
<td>activeClass</td>
<td>'on'</td>
<td>String</td>
<td>It'll be added to active element</td>
</tr>
</tbody>
</table>

---
## License
[MIT License](http://www.opensource.org/licenses/mit-license.html)
