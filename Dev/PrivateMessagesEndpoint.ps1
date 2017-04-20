# POST /api/block
# For blocking via inbox.
# id	
# fullname of a thing
# uh / X-Modhash header	
# a modhash

# POST /api/collapse_message
# Collapse a message
# See also: /api/uncollapse_message
# id	
# A comma-separated list of thing fullnames
# uh / X-Modhash header	
# a modhash

# POST /api/compose
# Handles message composition under /message/compose.
# api_type	
# the string json
# from_sr	
# subreddit name
# g-recaptcha-response	
# subject	
# a string no longer than 100 characters
# text	
# raw markdown text
# to	
# the name of an existing user
# uh / X-Modhash header	
# a modhash

# POST /api/del_msg
# Delete messages from the recipient's view of their inbox.
# id	
# fullname of a thing
# uh / X-Modhash header	
# a modhash

# POST /api/read_all_messages
# Queue up marking all messages for a user as read.
# This may take some time, and returns 202 to acknowledge acceptance of the request.
# uh / X-Modhash header	
# a modhash

# POST /api/read_message
# id	
# A comma-separated list of thing fullnames
# uh / X-Modhash header	
# a modhash

# POST /api/unblock_subreddit
# id	
# fullname of a thing
# uh / X-Modhash header	
# a modhash


# POST /api/uncollapse_message
# Uncollapse a message
# See also: /api/collapse_message
# id	
# A comma-separated list of thing fullnames
# uh / X-Modhash header	
# a modhash

# POST /api/unread_message
# id	
# A comma-separated list of thing fullnames
# uh / X-Modhash header	
# a modhash

# GET /message/where
# → /message/inbox
# → /message/unread
# → /message/sent
# This endpoint is a listing.
# mark	
# one of (true, false)
# mid	
# after	
# fullname of a thing
# before	
# fullname of a thing
# count	
# a positive integer (default: 0)
# limit	
# the maximum number of items desired (default: 25, maximum: 100)
# show	
# (optional) the string all
# sr_detail	
# (optional) expand subreddits
# Above comes back as 403, forbidden - Needed to add more permissions to Connect-RedditAccount function
# function Get-RedditInbox 