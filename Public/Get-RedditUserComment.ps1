function Get-RedditUserComment {
    <#
    .SYNOPSIS
        Get comments made by a specific user
    .DESCRIPTION
        Get comments made by a specific user.
        Uses the /user/$UserName/comments endpoint.
    .EXAMPLE
        $res = Get-RedditUserComment -Name "Poem_for_your_sprog"
        $poems = $res.data.children | %{$_.data.body}

        Gets all of the comments posted by 'Peom_for_your_sprog' and then stores the body 
        of them in a variable named $poems.
    .INPUTS
        A string or array of strings.
    .OUTPUTS
        A json response object.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("User")]
        [string[]]
        $Name        
    )
    
    begin {
    }
    
    process {
        foreach($UserName in $Name) {
            $uri = "https://oAuth.reddit.com/user/$UserName/comments"
            $response = Invoke-RedditApi -uri $uri
            $response 
        }
    }
    
    end {
    }
}