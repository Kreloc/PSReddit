function New-RedditPost {
    [CmdletBinding()]
    param (
        $Title,
        $Body,
        $Subreddit
    )
    
    begin {
    }
    
    process {
        $uri = "https://oAuth.reddit.com/api/submit?sr=$Subreddit&text=$Body&title=$Title&kind=self"
        $response = Invoke-RedditApi -uri $uri -Method Post
        If($response.success -eq $True)
        {
            "Post successfuly made to $Subreddit with a a title of $Title"
        }
        else {
            "Post was not made to $Subreddit"
        }
    }
    
    end {
    }
}

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