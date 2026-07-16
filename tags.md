---
layout: default
title: Browse by Tag
permalink: /tags/
---

# Browse by Tag

<p style="color:#666;">Select a topic to see matching posts.</p>

<div class="tag-cloud">
  {% assign sorted_tags = site.tags | sort %}
  {% for tag in sorted_tags %}
  <a class="tag-pill" href="{{ '/blog/' | relative_url }}?tag={{ tag[0] | slugify }}">{{ tag[0] }} <span class="tag-count">{{ tag[1].size }}</span></a>
  {% endfor %}
</div>

<style>
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 1.5rem;
}

.tag-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background-color: #f2f2f2;
  color: #222;
  border: 1px solid #e0e0e0;
  border-radius: 999px;
  padding: 8px 16px;
  font-size: 0.9rem;
  font-weight: 600;
  text-decoration: none;
  transition: background-color 0.2s ease, color 0.2s ease, transform 0.15s ease;
}

.tag-pill:hover {
  background-color: #000;
  color: #fff;
  transform: translateY(-2px);
}

.tag-count {
  background-color: rgba(0, 0, 0, 0.08);
  border-radius: 999px;
  padding: 1px 7px;
  font-size: 0.75rem;
}

.tag-pill:hover .tag-count {
  background-color: rgba(255, 255, 255, 0.2);
}
</style>
