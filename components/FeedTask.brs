
sub Init()
    m.top.functionName = "loadData"
end sub

sub loadData()
    if m.top.url <> "" and m.top.url <> invalid
        request = CreateObject("roUrlTransfer")
        request.SetCertificatesFile("common:/certs/ca-bundle.crt")
        request.InitClientCertificates()
        request.SetUrl(m.top.url)
        
        response = request.GetToString()
        
        if response <> ""
            m.top.content = parseM3U(response)
        end if
    end if
end sub

function parseM3U(m3uText as String) as Object
    rootNode = CreateObject("roSGNode", "ContentNode")
    rowNode = rootNode.CreateChild("ContentNode")
    rowNode.title = "Canales de Animacion"

    lines = m3uText.Split(chr(10))
    currentTitle = ""

    for each line in lines
        line = line.Trim()
        if line.StartsWith("#EXTINF:")
            titleParts = line.Split(",")
            if titleParts.Count() > 1
                currentTitle = titleParts[1]
            else
                currentTitle = "Canal"
            end if
        else if line.StartsWith("http")
            itemNode = rowNode.CreateChild("ContentNode")
            itemNode.title = currentTitle
            itemNode.url = line
            itemNode.streamFormat = "hls"
            currentTitle = ""
        end if
    end for

    return rootNode
end function
