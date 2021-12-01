# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def connect_db
    PG.connect( dbname: 'memos')
  end

  def load_memo(params = {})
    @memos = connect_db.exec( 'SELECT * FROM memos ORDER BY id' )
    connect_db.exec_params( "SELECT * FROM memos WHERE id = $1", params['id'] ).each { |values| @id, @title, @context = values['id'], values['title'], values['context'] } unless params.empty?
  end

  def add_memo(params)
    connect_db.exec_params( "INSERT INTO memos (title, context) VALUES ($1, $2)", [params['title'], params['context']])
  end

  def update_memo(params)
    connect_db.exec_params( "UPDATE memos SET title = $1, context = $2 WHERE id = $3", [params['title'], params['context'], params['id']] )
  end

  def delete_memo(id)
    connect_db.exec_params( "DELETE FROM memos WHERE id = $1", [id] )
  end
end
