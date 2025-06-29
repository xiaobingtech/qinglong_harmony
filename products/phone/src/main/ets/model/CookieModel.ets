import sql from "@liushengyi/smartdb"

export class CookieModel {
  @sql.SqlColumn(sql.ColumnType.INTEGER)
  id: number = 1
  @sql.SqlColumn(sql.ColumnType.TEXT)
  name: string = ''
  @sql.SqlColumn(sql.ColumnType.TEXT)
  url: string = ''

  constructor(id: number, name: string, url: string) {
    this.id = id
    this.name = name
    this.url = url
  }

}

class CookieDao {
  constructor() {
  }

  @sql.Sql("create table if not exists db_cookie ( id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,url TEXT NOT NULL)")
  createDb(): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlInsert("insert into db_cookie (name,url) values (#{cookie.name},#{cookie.url}) ")
  insertCookie(@sql.Param("cookie") cookie: CookieModel): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_cookie")
  @sql.ReturnType([CookieModel])
  findAll(): Promise<Array<CookieModel>> {
    return sql.PromiseNull()
  }

  @sql.SqlDelete("delete from db_cookie")
  deleteAll(): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("update db_cookie set name = #{cookie.name} url = #{cookie.url}  where id=#{cookie.id}")
  updateCookie(@sql.Param("cookie") cookie: CookieModel): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlDelete("delete from db_cookie where id=#{id}")
  deleteCookie(@sql.Param("id") id: number): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_cookie where #{cond} ")
  @sql.ReturnType([CookieModel])
  searchCookie(@sql.Param("cond",true) cond: string): Promise<Array<CookieModel>> {
    return sql.PromiseNull()
  }
}

export const cookieDao = new CookieDao()