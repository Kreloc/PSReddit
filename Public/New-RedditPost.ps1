function New-RedditPost {
    <#
    .SYNOPSIS
        A function for posting to a subreddit
    .DESCRIPTION
        A function for posting to a subreddit
        Uses the /api/submit endpoint
    .EXAMPLE
        New-RedditPost -Title "Powershell Rocks" -Body "This post was made using a PowerShell module" -Subreddit PSRedditFork
        Creates a text post titled PowerShell Rocks with the text body being what is in the Body parameter to
        the subreddit PSRedditFork (a private subreddit for testing this module)
    .EXAMPLE
        New-RedditPost -Title "PSReddit Module Fork" -Url "https://github.com/Kreloc/PSReddit" -Subreddit PSRedditFork
        Creates a link post titled PSReddit Module Fork with a url to the repo for this module to the subreddit PSRedditFork
    .NOTES
        Need to test getting the content of a text file or someway to get more content into the Body parameter
    #>
    [CmdletBinding(DefaultParameterSetName="self")]
    param (
        # Cannot be more than 300 characters
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [String]
        $Title,
        # Raw markdown of the post to be made if type is self
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true, ParameterSetName="self")]
        [String]        
        $Body,
        # A url to post to the subreddit
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true, ParameterSetName="url")]
        [String]        
        $Url,      
        # The name of the subreddit to submit a post to
        [Parameter(Position=2, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [String]         
        $Subreddit
    )
    
    begin {
    }
    
    process {
        If($PSCmdlet.ParameterSetName -eq "self")
        {
            $uri = "https://oAuth.reddit.com/api/submit?sr=$Subreddit&text=$Body&title=$Title&kind=self"
        }
        If($PSCmdlet.ParameterSetName -eq "url")
        {
            $uri = "https://oAuth.reddit.com/api/submit?sr=$Subreddit&url=$Url&title=$Title&kind=link"
        }
        $response = Invoke-RedditApi -uri $uri -Method Post
        If($response.success -eq $True)
        {
            Write-Verbose "Post successfuly made to $Subreddit with a a title of $Title"
            $response
        }
        else {
            Write-Verbose "Post was not made to $Subreddit"
            $response
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