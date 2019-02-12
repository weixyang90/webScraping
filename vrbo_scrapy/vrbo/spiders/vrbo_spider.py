from scrapy import Spider,Request
from vrbo.items import VrboItem
import re


class VrboSpider(Spider):
	name = 'vrbo_spider'
	allow_urls = ['https://www.vrbo.com/']
	start_urls = ['https://www.vrbo.com/results?petIncluded=false&ssr=true&adultsCount=2&q=United%20States']
	def parse(self, response):
		#text = response.xpath('//li[@class="Pager__li Pager__li--page"]/span/text()').extract_first()
		#_, per_page, total = map(lambda x: int(x), re.findall('\d+', text))
		number_pages = 100
		result_urls = ['https://www.vrbo.com/results?petIncluded=false&ssr=true&adultsCount=2&page={}&q=United%20States'.format(x) for x in range(1,number_pages+1)]
		for url in result_urls:
			yield Request(url=url, callback=self.parse_result_page)
	def parse_result_page(self, response):
		detail_urls = response.xpath('//div[@class="Hit__info"]/a/@href').extract()
		prices = response.xpath('//div[@class="HitInfo__price"]/span/span/text()').extract()
		p = re.compile('\d+')
		tempP = p.findall(str(prices))
		prices = tempP 
		print(len(detail_urls))
		print('=' * 50)
		for url in detail_urls:
			url = 'https://www.vrbo.com' + url
			for price in prices:
				yield Request(url=url, meta={'url': url, 'price':price}, callback=self.parse_review_page)
	def parse_review_page(self, response):
	# Retrieve the first reviews from meta
		# Find all the review tags
		url = response.meta['url']
		price = response.meta['price']
		try:
			title = response.xpath('//h1[@class="h2 position-relative margin-bottom-1x sm-margin-bottom-0x property-headline__headline"]/text()').extract_first()
			p5 = re.compile('[0-9a-zA-Z]*')
			temp6 = p5.findall(str(title))
			temp6 = filter(None, temp6)
			title = " ".join(temp6)
			title = title.rstrip()
		except IndexError:
			title = ""
#		try:
#			price = response.xpath('//div[@class="HitInfo__price"]/span/text()').extract_first()
#			print(price)
#		except IndexError:
#			price = ""
		try:
			numOfReview = response.xpath('//h2[@class="review-summary__header-overview-headline"]/strong/span/text()').extract_first()
			p = re.compile('\d+')
			temp = p.findall(str(numOfReview))[0]
			numOfReview = temp
			#print(numOfReview)
		except IndexError:
			numOfReview = 0
		try:
			review = response.xpath('//span[@class="review-summary__header-ratings-average"]/text()').extract_first()
			p1 = re.compile('\d+[\.]?[\d+]?')
			temp1 = p1.findall(str(review))[0]
			review = temp1
			#print(review)
		except IndexError:
			review = 0
		try:
			numOfBedroom = response.xpath('//div[@class="room-details--preview-item"]/span/text()').extract()[0]
			p = re.compile('\d+')
			temp2 = p.findall(str(numOfBedroom))[0]
			numOfBedroom = temp2
			#print(numOfBedroom)
		except IndexError:
			numOfBedroom = ""
		try:
			numOfBathroom = response.xpath('//ul[@class="amenities-subsection__section-summary list-unstyled margin-bottom-0x"]/li/div/div/text()').extract_first()
			p = re.compile('\d+')
			temp3 = p.findall(str(numOfBathroom))[0]
			numOfBedroom = temp3
			#print(numOfBedroom)
		except IndexError:
			numOfBathroom = ""
		try:
			sleep = response.xpath('//div[@class="room-details--preview-item"]/span/text()').extract()[1]
			p = re.compile('\d+')
			temp4 = p.findall(str(sleep))[0]
			sleep = temp4
			#print(sleep)
		except IndexError:
			sleep = ""
		try:
			house = response.xpath('//ul[@class="list-unstyled margin-bottom-0x"]/li/span/text()').extract()[0]
			#print(house)
		except IndexError:
			house = ""
		try:
			owner = response.xpath('//div[@class="owner-details__details-section__name"]/h4/text()').extract_first()
			#print(owner)
		except IndexError:
			owner = ""
		try:
			location = response.xpath('//div[@class="listing-overview__location micro"]/text()').extract_first()
			L = location.split(',')
			if(len(L) == 4):
				city = L[1]
				state = L[2]
			elif(len(L) == 3):
				city = L[0]
				state = L[1]
			city = city.strip()
			state = state.strip()
		except IndexError:
			city = ""

		item = VrboItem()
		item['title'] = title
		item['price'] = price
		item['numOfReview'] = numOfReview
		item['review'] = review
		item['numOfBedroom'] = numOfBedroom
		item['numOfBathroom'] = numOfBathroom
		item['sleep'] = sleep
		item['house'] = house
		item['owner'] = owner
		item['city'] = city
		item['state'] = state
		item['url'] = url
		yield item