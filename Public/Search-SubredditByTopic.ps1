function Search-SubredditByTopic
{
    <#
    .SYNOPSIS
        A function for finding subreddits by a topic query.
    .DESCRIPTION
        A function for finding subreddits by a topic query.
        Uses the /api/subreddits_by_topic endpoint
    .EXAMPLE
        Search-SubredditByTopic -Filter "helpdesk"
        Returns subreddits found with a topic relating to helpdesk.
    #>  
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("query")]
        [string]
        $Filter = 'all'  
    )
    begin {}
    process {
        $uri = "https://oAuth.reddit.com/api/subreddits_by_topic?query=$Filter"
        $response = Invoke-RedditApi -uri $uri           
        $response
    }
    end {}
}