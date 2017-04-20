function Search-RedditSub {
    <#
    .SYNOPSIS
        A function for searching for subreddits.
    .DESCRIPTION
        A function for searching for subreddits.
        Uses the /subreddits/search endpoint
    .EXAMPLE
        Search-RedditSub -Filter "powershell"
        Will return search results for the query looking for subreddits related to PowerShell.

    .NOTES
        Function added by Kreloc on 4/19/2017
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("query")]
        [string]
        $Filter = 'all'       
    )
    
    begin {
    }
    
    process {
        $uri = "https://oAuth.reddit.com/subreddits/search?q=$Filter"
        $response = Invoke-RedditApi -uri $uri
        $response.data.children | ForEach-Object {
            $_.data | ForEach-Object { $_.PSObject.TypeNames.Insert(0,'PSReddit.Listing'); $_  }
        }
    }
    
    end {
    }
}