require 'yaml/store'
require_relative 'task'

class TaskManager
  def self.database
    @database ||= YAML::Store.new("db/task_manager")
  end

  def self.create(task)
    database.transaction do
      database['tasks'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
    end
  end

  def self.raw_tasks
    database.transaction do
      database['tasks'] || []
    end
  end

  def self.all
    raw_tasks.map { |data| Task.new(data) }
  end

  def self.raw_task(id)
    raw_tasks.find { |task| task["id"] == id}
  end

  def self.find(id)
    Task.new(raw_task(id))
  end

  def self.update(id, data) #Schoolwork
    database.transaction do
      target = database['tasks'].find { |task| task['id'] == id }
      # target = {"title => "Homework", "description" => "math" } -- it's grabbing the task by it's id and giving that task/description back to us

      target['title'] = data[:title] #resetting the previous task title of "Homework" to "Schoolwork"
      target['description'] = data[:description]
    end
  end

  def self.delete(id)
    database.transaction do
      database['tasks'].delete_if { |task| task['id'] == id }
    end
  end
end
