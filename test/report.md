['172.21.77.46', '-', '-', '03/Jun/2019:01:30:26', '+0900', 'POST', '/U11/U11A10APP/U11000000.json?ServiceName=U11010100-ajax-service&alertLi172.21.55.206', '-', '-', '03/Jun/2019:02:13:13', '+0900', 'POST', '/U11/U11A10APP/U11000000.mvc?ServiceName=U11010100-service&login=1', 'HTTP/1.1', '200', '175009', '3']

['172.21.95.115', '-', '-', '03/Jun/2019:01:30:24', '+0900', 'GET', '/U11/U11A10APP/U11000000.json?ServiceName=172.21.20.77', '-', '-', '03/Jun/2019:02:17:19', '+0900', 'GET', '/U11/U11A10APP/U11000000.mvc?ServiceName=U11010100-service&login=1&reloadFlag=Y', 'HTTP/1.1', '302', '-', '0']



['172.21.20.175', '-', '-', '03/Jun/2019:08:34:45', '+0900',                                                                                                      '-', '408', '-', '0']


['172.23.18.45', '-', '-', '02/Jun/2019:23:55:01', '+0900', 'GET', '/U11/U11A10APP/U11000000.mvc?ServiceName=U11010100-service&login=1&reloadFlag=Y', 'HTTP/1.1', '200', '165861', '0']

## http status code
https://en.wikipedia.org/wiki/List_of_HTTP_status_codes

## http status code showed in data

### Normal
- '200', OK
- '206', Partial Content
- '302', Found
- '304', Not Modified

### Client Error
- '400', Bad Request
- '403', Forbidden
- '404', Not Found
- '408', Request Timeout

### Server Error
- '500', Internel Server Error


4013073
200    3023565
304     910574
302      60952
404      16934
408        838
206        123
500         56
400         18
403         13
Name: status, dtype: int64

200    0.753429
304    0.226902
302    0.015188
404    0.004220
408    0.000209
206    0.000031
500    0.000014
400    0.000004
403    0.000003
Name: status, dtype: float64







**********************************************

