registerClick = (resultCallback) ->
  document.addEventListener 'click', (event) ->
    element = event.target
    path = getXpath(element)
    resultCallback('click', {path})


# http://stackoverflow.com/questions/2631820/im-storing-click-coordinates-in-my-db-and-then-reloading-them-later-and-showing/2631931#2631931
getXpath = (element) ->
    if element.id
        return "id('#{element.id}')"
    else if element == document.body
        return element.tagName

    ix = 0
    siblings = element.parentNode.childNodes
    for sibling in siblings
        if sibling == element
            return "#{getXpath(element.parentNode)}/#{element.tagName}[#{ix+1}]"
        if sibling.nodeType == 1 && sibling.tagName == element.tagName
            ix++


class EventData
  constructor: ->
    @data = []

  addData: (name, data) =>
    @data.push({name: name, data: data})


# init code
allData = new EventData
registerClick(allData.addData)
