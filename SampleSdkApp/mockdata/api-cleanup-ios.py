import oauth2 as oauth
import simplejson
import random as rand
import os


key= 'f04f5af0-5be0-4ae6-a1f1-8d418c0d7e6b'
secret= '7a9a2b20-d4de-4d46-9c0b-f1653f0f1089'
url= 'http://stage.getsocialize.com/v1'
auth_url= 'http://stage.getsocialize.com/v1/authenticate/'


sig = oauth.SignatureMethod_HMAC_SHA1()    
auth_url = '/authenticate/'
purge_url = '/all_data/'
entity_url = '/entity/'
comment_url= '/comment/'
share_url='/share/'
like_url='/like/'
view_url='/view/'
udid = '1234566788'



def gen_comment(entity_key,i):
    text = 'POST comment #%i'%(i)
    return {'entity_key': entity_key, 'text': text, 'lat':rand.random()*90, 'lng':rand.random()*90}

def gen_like_and_view(entity_key):
    return {'entity_key': entity_key, 'lat':rand.random()*90, 'lng':rand.random()*90}

def gen_share(entity_key, medium):
    share_dic={1:'Twitter',
                2:'Facebook',
                3:'Email',
                4:'Other',             
            }
    text = 'POST SHARE on %s'%(share_dic[medium])
    return {'entity_key': entity_key,'text':text, 'medium':medium, 'lat':rand.random()*90, 'lng':rand.random()*90}     

def print_json(resp, fname=None):
    item = simplejson.loads(resp)['items']
    if not fname:
        print simplejson.dumps(item,sort_keys=True, indent=4)
    else:
        print '\t**generate outfile:',fname
        f = open(fname+'.js', 'w')
        f.write(fname+'='+simplejson.dumps(item,sort_keys=True, indent=4)+';')
        f.close()                                   



#android_conf_file = '../sample/assets/sample-app.conf'
#ios_conf_file = ''

### READ CONFIGURATION FILE##
#file = open(android_conf_file,'r')
#for line in file :
    #li=line.strip()
    #if not li.startswith("#"):
        #if li.startswith('socialize.consumer.key'):
            #key = li[li.find('=')+1:]
        #elif li.startswith('socialize.consumer.secret'):
            #secret = li[li.find('=')+1:]
        #elif li.startswith('socialize.api.url'):
            #url =  li[li.find('=')+1:]
            #if not url.startswith('http'):    ## if not start with http
                #url = 'http://'+url           ## using http:// protocal
        ##print line.rstrip()


print 'KEY=',key
print 'SECRET=',secret
print 'URL=',url
auth_url = url+auth_url
print 'AUTH_URL=',auth_url
## AUTHENTICATION ##
consumer = oauth.Consumer( key, secret)
client = oauth.Client( consumer) 
payload = simplejson.dumps({ 'payload': { 'udid': udid}})
auth_resp = client.request(auth_url ,'POST', body='payload='+simplejson.dumps({'udid':udid}))
auth_cont = simplejson.loads(auth_resp[1])
oauth_secret= auth_cont['oauth_token_secret']
oauth_token= auth_cont['oauth_token']
token = oauth.Token(oauth_token,oauth_secret) 

## PURGE ALL DATA ##
req_url = url + purge_url
req = oauth.Request.from_consumer_and_token( consumer,
                                            http_method='POST',
                                            parameters = {},
                                            http_url = req_url,
                                            token = token)
req.sign_request(sig, consumer, token)
resp = client.request(uri=req_url ,method='POST', headers=req.to_header())
print resp[1]

print '#'*20
print '## REMOVE json files ##'
print '#'*20  
def remove(fname):
    try:
        os.remove(fname)
        print '\t %s DELETED'%fname
    except OSError:
        print '\tfile not found', fname       
remove('comments.js')
remove('shares.js')
remove('likes.js')
remove('views.js')


## Create Entity
print '#'*20
print '## CREATE ENTITY ##'
print '#'*20

entities = [ {'key':'http://entity1.com','name':'First Entity'},
             {'key':'http://entity2.com','name':'Second Entity'}
            ]
payload = simplejson.dumps(entities)
req_url = url+entity_url
req = oauth.Request.from_consumer_and_token( consumer,
                                            http_method='POST',
                                           # parameters = {'payload': payload},
                                            http_url = req_url,
                                            token = token)
req.sign_request(sig, consumer, token)

client=oauth.Client(consumer,token)
resp=client.request(uri=req_url, method='POST', body='payload='+payload)
print_json(resp[1],'entities')
## Create Comment for entity1



print '#'*20
print '## CREATE COMMENT ##'
print '#'*20
            
comments = [ gen_comment('http://entity1.com', i) for i in range(10)]
req_url = url+comment_url
payload=simplejson.dumps(comments)
resp=client.request(uri=req_url, method='POST', body='payload='+payload)
#print resp[1]
print_json(resp[1],'comments')



## Create Like for both entities

print '#'*20
print '## CREATE LIKES ##'
print '#'*20  

likes = [ gen_like_and_view('http://entity1.com') , gen_like_and_view('http://entity2.com')]
req_url = url+like_url 
payload=simplejson.dumps(likes)
resp=client.request(uri=req_url, method='POST', body='payload='+payload)
print_json(resp[1],'likes')


## Create Share for both entities

print '#'*20
print '## CREATE SHARES ##'
print '#'*20  

shares = [ gen_share('http://entity1.com',1) , gen_share('http://entity2.com',2)]
req_url = url+share_url 
payload=simplejson.dumps(shares)
resp=client.request(uri=req_url, method='POST', body='payload='+payload)
print_json(resp[1],'shares')


print '#'*20
print '## CREATE VIEWS ##'
print '#'*20  

views = [ gen_like_and_view('http://entity1.com') , gen_like_and_view('http://entity2.com')]
req_url = url+view_url 
payload=simplejson.dumps(views)
resp=client.request(uri=req_url, method='POST', body='payload='+payload)
print_json(resp[1],'views')



