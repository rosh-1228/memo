# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def connect_db
    PG.connect(dbname: 'memos')
  end

  def create_db
    result = connect_db.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'").cmd_tuples
    connect_db.exec('CREATE TABLE memos( id SERIAL, title TEXT NOT NULL, text TEXT )') if result.zero?
  end
end
