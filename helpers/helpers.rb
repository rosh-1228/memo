# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def conect_db
    PG.connect( dbname: 'memos')
  end

  def load_memo(params = {})
    @memos = conect_db.exec( "SELECT * FROM memos ORDER BY id" )
    conect_db.exec( "SELECT * FROM memos WHERE id = #{params['id']}" ).each { |values| @id, @title, @context = values['id'], values['title'], values['context'] } unless params.empty?
  end

  def add_memo(params)
    conect_db.exec( "INSERT INTO memos (title, context) VALUES ('#{params['title']}', '#{params['context']}')" )
  end

  def update_memo(params)
    conect_db.exec( "UPDATE memos SET title = '#{params['title']}', context = '#{params['context']}' WHERE id = #{params['id']}" )
  end

  def delete_memo(id)
    conect_db.exec( "DELETE FROM memos WHERE id = #{id}" )
  end
end
