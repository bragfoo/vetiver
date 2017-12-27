##首页
### banner
```GET```
```/home/banners```
###主页内容
```GET```
```/home_center```
###主页动态
```GET```
```/home/latest```
##视频/文章页
###文章
获取文章
```GET```
```items/{文章的ID}```

删除发布的文章
```DELETE```
```items/{文章的ID}```
###视频
获取视频
```GET``` ```items/{视频的ID}?format=video```

删除发布的视频
```DELETE``` ```items/{视频的ID}```
##分类页
###大分类
```GET``` ```/home/navs```
###二级分类
```GET``` ```/home/navs/%ld```
##评论页
获取评论列表
```GET``` ```items/{文章/视频的ID}/comments```

发表评论
```POST``` ```items/{文章/视频的ID}/comments```
##MSG
###通知中心
```GET``` ```/messages```
###新消息类型
```/message_types```
###关注相关
关注用户 ```POST``` ```/users/{用户的ID}/follows```

取消关注用户 ```DELETE``` ```/users/{自己的用户ID}/follows/users/{取消关注的用户ID}```

关注列表 ```GET``` ```/users/{用户的ID}/follows```

粉丝列表 ```GET``` ```/users/{用户的ID}/fans```