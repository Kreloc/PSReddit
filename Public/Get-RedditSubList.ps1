function Get-RedditSubList {
    [CmdletBinding()]
    <#
    .SYNOPSIS
        A function for getting a list of subreddits
    .DESCRIPTION
        A function for getting a list of subreddits
        Uses the /subreddits/where endpoint
    .EXAMPLE
        Get-RedditSubList
        Gets the subreddits from the default where listing

    .EXAMPLE
        Get-RedditSubList -Type new
        Get the subreddits from the new where listing

    #>
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("popular","new","gold","default")] 
        [String]
        $Type = "default"        
    )
    
    begin {
    }
    
    process {
        $uri = "https://oAuth.reddit.com/subreddits/$Type"
        $response = Invoke-RedditApi -uri $uri
        $response.data.children | ForEach-Object {
            $_.data | ForEach-Object { $_.PSObject.TypeNames.Insert(0,'PSReddit.Listing'); $_  }
        }

    }
    
    end {
    }
}