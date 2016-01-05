user = User.create({
  username: 'emaraschio',
  password: 'taskstest',
  email: 'ezequiel@deviget.com',
  phone_number: '123 1234 1234'
})

task = Task.new({
  description: "A new note about work and each fields of this thing",
  category: 'work',
  due_date: Date.today
})
user.add_task task

task = Task.new({
  description: "This is an event on Palermo",
  category: 'personal',
  due_date: Date.today,
  complete: true
})
user.add_task task
