#  What would I change given more time:

- Handle errors by the API on completion instead of just a print statement.
- Handle errors thrown by saving data to file.
- Add a loading state to avoid empty views when there's no cache. (maybe use the default location, load that and when I receive the location load again for that.)
- Move the DateFormatter from the Model to avoid creating one for each call of the property.
- Add Documentation and more Comments.
- Add Tests.
- Add a `Repository/Service` layer between the API, File Loading and the ViewModels to make the code easier to test.
