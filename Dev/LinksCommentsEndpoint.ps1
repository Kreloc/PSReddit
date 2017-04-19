# POST /api/comment
# Submit a new comment or reply to a message.
# parent is the fullname of the thing being replied to. Its value changes the kind of object created by this request:
# the fullname of a Link: a top-level comment in that Link's thread. (requires submit scope)
# the fullname of a Comment: a comment reply to that comment. (requires submit scope)
# the fullname of a Message: a message reply to that message. (requires privatemessages scope)
# text should be the raw markdown body of the comment or message.
# To start a new message thread, use /api/compose.
# api_type	
# the string json
# text	
# raw markdown text
# thing_id	
# fullname of parent thing
# uh / X-Modhash header	
# a modhash

# POST /api/del
# Delete a Link or Comment.
# id	
# fullname of a thing created by the user
# uh / X-Modhash header

# POST /api/editusertext 
# Edit the body text of a comment or self-post.
# api_type	
# the string json
# text	
# raw markdown text
# thing_id	
# fullname of a thing created by the user
# uh / X-Modhash header	
# a modhash

# POST /api/hide
# Hide a link.
# This removes it from the user's default view of subreddit listings.
# See also: /api/unhide.
# id	
# A comma-separated list of link fullnames
# uh / X-Modhash header	
# a modhash

# GET [/r/subreddit]/api/info
# Return a listing of things specified by their fullnames.
# Only Links, Comments, and Subreddits are allowed.
# id	
# A comma-separated list of thing fullnames
# url	
# a valid URL

# POST /api/submit
# Submit a link to a subreddit.
# Submit will create a link or self-post in the subreddit sr with the title title. If kind is "link", then url is expected to be a valid URL to link to. Otherwise, text, if present, will be the body of the self-post.
# If a link with the same URL has already been submitted to the specified subreddit an error will be returned unless resubmit is true. extension is used for determining which view-type (e.g. json, compact etc.) to use for the redirect that is generated if the resubmit error occurs.
# api_type	
# the string json
# app	
# extension	
# extension used for redirects
# flair_id	
# a string no longer than 36 characters
# flair_text	
# a string no longer than 64 characters
# g-recaptcha-response	
# kind	
# one of (link, self, image)
# location_lat	
# location_long	
# location_name	
# a string no longer than 1024 characters
# resubmit	
# boolean value
# sendreplies	
# boolean value
# sr	
# subreddit name
# text	
# raw markdown text
# title	
# title of the submission. up to 300 characters long
# uh / X-Modhash header	
# a modhash
# url	
# a valid URL