# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class VrboItem(scrapy.Item):
	# define the fields for your item here like:
	# name = scrapy.Field()
	title = scrapy.Field()
	price = scrapy.Field()
	numOfReview = scrapy.Field()
	review = scrapy.Field()
	numOfBedroom = scrapy.Field()
	numOfBathroom = scrapy.Field()
	sleep = scrapy.Field()
	house = scrapy.Field()
	owner = scrapy.Field()
	city = scrapy.Field()
	state = scrapy.Field()
	url = scrapy.Field()
