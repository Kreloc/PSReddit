function Get-RedditInbox {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("inbox","unread","sent")] 
        [String]
        $Type = "inbox"     
    )
    
    begin {
        $uri = "https://oAuth.reddit.com/message/$Type"
        $response = Invoke-RedditApi -uri $uri
        $response.data.children | ForEach-Object {
            $_.data                
        } 
    }
    
    process {
    }
    
    end {
    }
}