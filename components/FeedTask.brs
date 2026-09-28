sub Init()
    m.top.functionName = "loadData"
end sub

sub loadData()
    parentContent = CreateObject("roSGNode", "ContentNode")
    
    if m.top.url <> ""
        request = CreateObject("roUrlTransfer")
        request.SetUrl(m.top.url)
        request.SetCertificatesFile("common:/certs/ca-bundle.crt")
        request.InitClientCertificates()
        
        jsonString = request.GetToString()
        json = ParseJson(jsonString)
        
        if json <> invalid
            rowNode = parentContent.CreateChild("ContentNode")
            rowNode.title = "Películas Disponibles"
            
            for each item in json
                itemNode = rowNode.CreateChild("ContentNode")
                itemNode.title = item.title
                itemNode.HDPosterUrl = item.poster
                itemNode.url = item.stream_url
                itemNode.streamFormat = "hls"
            end for
        end if
    end if

    m.top.content = parentContent
end sub
