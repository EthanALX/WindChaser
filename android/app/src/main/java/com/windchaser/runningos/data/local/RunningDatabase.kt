package com.windchaser.runningos.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

/**
 * Room 数据库
 */
@Database(
    entities = [ActivityEntity::class, RouteEntity::class],
    version = 1,
    exportSchema = false
)
abstract class RunningDatabase : RoomDatabase() {
    abstract fun activityDao(): ActivityDao
    abstract fun routeDao(): RouteDao

    companion object {
        private const val DATABASE_NAME = "running_db"

        @Volatile
        private var INSTANCE: RunningDatabase? = null

        fun getInstance(context: Context): RunningDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    RunningDatabase::class.java,
                    DATABASE_NAME
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}
