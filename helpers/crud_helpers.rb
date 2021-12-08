# frozen_string_literal: true

helpers do
  def load_memo(params = {})
    query = 'SELECT * FROM memos'
    if params.empty?
      @memos = connect_db.exec("#{query} ORDER BY id")
    else
      memo = connect_db.exec_params("#{query} WHERE id = $1", [params['id']]).first
      @id = memo['id']
      @title = memo['title']
      @text = memo['text']
    end
  end

  def add_memo(params)
    connect_db.exec_params('INSERT INTO memos (title, text) VALUES ($1, $2)', [params['title'], params['text']])
  end

  def update_memo(params)
    connect_db.exec_params('UPDATE memos SET title = $1, text = $2 WHERE id = $3', [params['title'], params['text'], params['id']])
  end

  def delete_memo(id)
    connect_db.exec_params('DELETE FROM memos WHERE id = $1', [id])
  end
end
