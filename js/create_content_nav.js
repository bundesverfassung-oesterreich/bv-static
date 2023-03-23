var parent = document.getElementById("home-collapse")
var edition_div = document.getElementById("section");
var h3s = edition_div.getElementsByTagName("h3");
var indices = h3s.length;
for (var i = 0; i < indices; i++) {
    var h3 = h3s[i];
    var text = h3.textContent;
    var new_id = "h3_"+i;
    h3.setAttribute('id', new_id);
    var li = document.createElement("li");
    var a = document.createElement("a");
    a.setAttribute("href", "#"+new_id);
    li.appendChild(a);
    var newContent = document.createTextNode(text);
    a.appendChild(newContent);
    parent.appendChild(li)
}