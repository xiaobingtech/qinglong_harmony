import sql from "@liushengyi/smartdb"

export class AccountModel {
  @sql.SqlColumn(sql.ColumnType.INTEGER)
  id: number = 1
  @sql.SqlColumn(sql.ColumnType.TEXT)
  server: string = ''
  @sql.SqlColumn(sql.ColumnType.TEXT)
  username: string = ''
  @sql.SqlColumn(sql.ColumnType.TEXT)
  password: string = ''
  @sql.SqlColumn(sql.ColumnType.INTEGER)
  useAccount: number = 1
  @sql.SqlColumn(sql.ColumnType.TEXT)
  client_id: string = ''
  @sql.SqlColumn(sql.ColumnType.TEXT)
  client_secret: string = ''
  @sql.SqlColumn(sql.ColumnType.INTEGER)
  is_current: number = 0
  @sql.SqlColumn(sql.ColumnType.TEXT)
  remark: string = ''

  constructor(id: number, server: string, username: string, password: string, useAccount: number, client_id: string,
    client_secret: string, is_current: number, remark: string) {
    this.id = id
    this.server = server
    this.username = username
    this.password = password
    this.useAccount = useAccount
    this.client_id = client_id
    this.client_secret = client_secret
    this.is_current = is_current
    this.remark = remark
  }

}

class AccountDao {
  constructor() {
  }

  @sql.Sql("create table if not exists db_account ( id INTEGER PRIMARY KEY AUTOINCREMENT,server TEXT NOT NULL,username TEXT,password TEXT,useAccount INTEGER,client_id TEXT,client_secret TEXT,is_current INTEGER,remark TEXT )")
  createDb(): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlInsert("insert into db_account (server,username,password,useAccount,client_id,client_secret,is_current,remark) values (#{account.server},#{account.username},#{account.password},#{account.useAccount},#{account.client_id},#{account.client_secret},#{account.is_current},#{account.remark}) ")
  insertAccount(@sql.Param("account") account: AccountModel): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_account where server=#{server}")
  @sql.ReturnListType(AccountModel)
  findAccount(@sql.Param("server") server: string): Promise<Array<AccountModel>> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_account")
  @sql.ReturnListType(AccountModel)
  findAll(): Promise<Array<AccountModel>> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_account where is_current = 1")
  @sql.ReturnListType(AccountModel)
  findUpdateAccount(): Promise<Array<AccountModel>> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("update db_account set is_current = 1 where server=#{account.server}")
  updateCurrentAccount(@sql.Param("account") account: AccountModel): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("update db_account set is_current = 0 where server=#{account.server}")
  deleteCurrentAccount(@sql.Param("account") account: AccountModel): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlDelete("delete from db_account")
  deleteAll(): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlDelete("delete from db_account where server=#{server}")
  deleteAccount(@sql.Param("server") server: string): Promise<void> {
    return sql.PromiseNull()
  }

  @sql.SqlQuery("select * from db_account where #{cond} ")
  @sql.ReturnListType(AccountModel)
  searchAccount(@sql.Param("cond",true) cond: string): Promise<Array<AccountModel>> {
    return sql.PromiseNull()
  }
}

export const accountDao = new AccountDao()