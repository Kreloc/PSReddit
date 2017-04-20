function Get-RedditSubRecommendation {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string]
        $Name = 'all'      
    )
    
    begin {

    }
    
    process {
        $Names = $Name -join ','
        $uri = "https://oAuth.reddit.com/api/recommend/sr/$Names"
        $response = Invoke-RedditApi -uri $uri
        # Don't think formatting is necessary for this response
        $response
    }
    
    end {
    }
}