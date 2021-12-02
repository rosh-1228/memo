# frozen_string_literal: true

helpers do
  def load_memo(params = {})
    query = 'SELECT * FROM memos'
    if params.empty?
      @memos = connect_db.exec("#{query} ORDER BY id")
    else
      connect_db.exec_params("#{query} WHERE id = $1", [params['id']]).each do |values|
        @id = values['id']
        @title = values['title']
        @context = values['context']
      end
    end
  end

  def add_memo(params)
    connect_db.exec_params('INSERT INTO memos (title, context) VALUES ($1, $2)', [params['title'], params['context']])
  end

  def update_memo(params)
    connect_db.exec_params('UPDATE memos SET title = $1, context = $2 WHERE id = $3', [params['title'], params['context'], params['id']])
  end

  def delete_memo(id)
    connect_db.exec_params('DELETE FROM memos WHERE id = $1', [id])
  end
end
