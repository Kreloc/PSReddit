function Get-RedditSubsUser {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        # Parameter help description
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("subscriber","contributor","moderator")] 
        [String]
        $Type = "subscriber"                
    )
    
    begin {
    }
    
    process {
        $uri = "https://oAuth.reddit.com/subreddits/mine/$Type"
        Write-Verbose "Sending a uri of $($uri)"
        $response = Invoke-RedditApi -uri $uri
        $response.data.children | ForEach-Object {
            $_.data | ForEach-Object { $_.PSObject.TypeNames.Insert(0,'PSReddit.Listing'); $_  }
        }   
    }
    
    end {
    }
}