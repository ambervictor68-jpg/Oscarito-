sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.videoPlayer = m.top.FindNode("videoPlayer")
    m.rowList.ObserveField("rowItemSelected", "onItemSelected")

    ' Cargar lista M3U de Animación
    m.feedTask = CreateObject("roSGNode", "FeedTask")
    m.feedTask.url = "https://iptv-org.github.io/iptv/categories/animation.m3u"
    m.feedTask.ObserveField("content", "onDataLoaded")
    m.feedTask.control = "RUN"
end sub

sub onDataLoaded()
    if m.feedTask.content <> invalid
        m.rowList.content = m.feedTask.content
        m.rowList.SetFocus(true)
    end if
end sub

sub onItemSelected(event as Object)
    selectedIndices = event.GetData()
    rowContent = m.rowList.content.GetChild(selectedIndices[0])
    selectedContent = rowContent.GetChild(selectedIndices[1])

    m.videoPlayer.content = selectedContent
    m.videoPlayer.visible = true
    m.videoPlayer.SetFocus(true)
    m.videoPlayer.control = "play"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press and key = "back"
        if m.videoPlayer.visible
            m.videoPlayer.control = "stop"
            m.videoPlayer.visible = false
            m.rowList.SetFocus(true)
            return true
        end if
    end if
    return false
end function

