from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from scrapy.http.request import Request
from first_proj.items import FirstProjItem

class FooSpider(BaseSpider):
	name = "foo"
	allowed_domains = ["foo.org"]
	start_urls = ["http://www.dmoz.org/Computers/Programming/Languages/Python/Books/", 
                "http://www.dmoz.org/Computers/Programming/Languages/Python/Resources/"]

	def parse(self,response):
		hxs = HtmlXPathSelector(response)
		sites = hxs.select("//ul//li")
		items = []
		for site in sites:
			item = FirstProjItem()
			item['title'] = site.select('').extract()
			item['link'] = site.select('').extract()
			item['content'] = site.select('').extract()
			items.append(item)
		for item in items:
			yield item

