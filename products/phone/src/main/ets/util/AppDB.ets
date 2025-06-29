import sql from '@liushengyi/smartdb';
import relationalStore from '@ohos.data.relationalStore';
import { accountDao } from '../model/AccountModel';
import { cookieDao } from '../model/CookieModel';

class AppDB {
  static DB_VERSION: number = 3

  initDb(context: Context) {
    sql.dbHelper.initDb(context, "qinglong.db", AppDB.DB_VERSION, new AppDbOpenHelper())
    //配置RdbStore属性
    //sql.dbHelper.initDbWithConfig
  }
}

class AppDbOpenHelper extends sql.DbOpenHelper {
  constructor() {
    super()
  }

  async onCreate(db: relationalStore.RdbStore) {
    //用户表
    await accountDao.createDb()
    await cookieDao.createDb()
  }

  async onUpgrade(db: relationalStore.RdbStore, oldVersion: number, newVersion: number) {
    if (oldVersion <= 2) {
      //升级操作
    }
  }
}

export default new AppDB()