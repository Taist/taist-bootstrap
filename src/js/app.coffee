data =
  tags: [
    { id: 'some-unique-id', name: 'tai.st', color: 'DeepSkyBlue' }
    { id: 'another-unique-id', name: 'react', color: 'SteelBlue' }
  ]

module.exports =
  api: null

  storage:
    getTagsArray: ->
      data.tags

    getTagsIds: ->
      data.tags.map (tag) -> tag.id

    getTagsMap: ->
      result = {}
      data.tags.forEach (tag) ->
        result[tag.id] = tag
      result
