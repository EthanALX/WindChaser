package com.windchaser.runningos.di

import android.content.Context
import com.windchaser.runningos.data.local.ActivityDao
import com.windchaser.runningos.data.local.RouteDao
import com.windchaser.runningos.data.local.RunningDatabase
import com.windchaser.runningos.data.repository.RunningRepositoryImpl
import com.windchaser.runningos.domain.repository.RunningRepository
import com.google.gson.Gson
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt 依赖注入模块
 */
@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRunningDatabase(
        @ApplicationContext context: Context
    ): RunningDatabase {
        return RunningDatabase.getInstance(context)
    }

    @Provides
    @Singleton
    fun provideActivityDao(
        database: RunningDatabase
    ): ActivityDao {
        return database.activityDao()
    }

    @Provides
    @Singleton
    fun provideRouteDao(
        database: RunningDatabase
    ): RouteDao {
        return database.routeDao()
    }

    @Provides
    @Singleton
    fun provideGson(): Gson {
        return Gson()
    }

    @Provides
    @Singleton
    fun provideRunningRepository(
        activityDao: ActivityDao,
        routeDao: RouteDao,
        gson: Gson
    ): RunningRepository {
        return RunningRepositoryImpl(activityDao, routeDao, gson)
    }
}
