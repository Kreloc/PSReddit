# internal invoke function
function Invoke-RedditApi {
    [CmdletBinding()]
    param (
        $uri,
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken
    )
    
    begin {
    }
    
    process {
        Write-Verbose "Sending a uri of $($uri)"
        try {
            $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)                
        }
        catch {
            # Expand this catch for the different errors returned
            Write-Error $_
            If($_.Exception -match 400)
            {
                Write-Warning "The uri sent was seen as malformed, check the content of $($uri)"
            }
            If($_.Exception -match 403)
            {
                Write-Warning "This portion of the API is forbidden using the current authorized user"
            }
            If($_.Exception -match 404)
            {
                Write-Warning "No results were found using the uri: $($uri)"
            }
            If($_.Exception -match 401)
            {
                Write-Warning "The last attempt against the Reddit API failed. May need to regenerate API token"
            }
            If($_.Exception -match 500)
            {
                Write-Warning "There was an error at the other end. Try again later"
            }           
        }
        $response        
    }
    
    end {
    }
}
# end internal invoke function

# get /r/subreddit/about
# function Get-RedditSubAbout


# get /api/recommend/sr/$srnames
# function Get-RedditSubRecommendation

# get /r/subreddit/api/submit_text

# get /api/subreddits_by_topic
# function Search-SubredditByTopic

# get /r/subreddit/sidebar
# function Get-RedditSubSideBar

# get /subreddits/mine/where
# function Get-RedditSubsUser 

# get /r/subreddit/<new,hot,etc>
# function Get-RedditSubListing 