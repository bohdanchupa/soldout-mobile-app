export const login = (state, { accessToken, firstName, lastName, mail, phone }) => {
  state.accessToken = accessToken
  state.user.firstName = firstName
  state.user.lastName = lastName
  state.user.mail = mail
  state.user.phone = phone
  if (accessToken) state.user.logined = true
}

export const logout = (state) => {
  state.accessToken = null
  state.user.firstName = null
  state.user.lastName = null
  state.user.mail = null
  state.user.phone = null
  state.user.logined = false
  state.error = null
}

export const showDetails = (state, { show }) => {
  state.showDetailsOnEntryScreen = show
}

export const setError = (state, { error }) => {
  console.log(error)
  state.error = error
}

export const setDateForDetails = (state, { date }) => {
  state.showDetailsOnEntryScreenForDate = date
}

export const fetchingData = (state, { isFetching }) => {
  state.fetchingData = isFetching
}
