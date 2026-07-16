---
layout: default
title: Browse by Tag
permalink: /tags/
---

# Browse by Tag

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
## {{ tag[0] }}

<ul>
  {% for post in tag[1] %}
  <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> <span style="color:#999; font-size:0.85rem;">— {{ post.date | date: "%B %-d, %Y" }}</span></li>
  {% endfor %}
</ul>
{% endfor %}
