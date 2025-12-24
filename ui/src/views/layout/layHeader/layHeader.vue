<!--
 * @Author: LPY
 * @Date: 2025-05-30 15:21:14
 * @LastEditors: LPY
 * @LastEditTime: 2025-08-26 17:57:09
 * @FilePath: \glkvm-cloud\web-ui\src\views\layout\layHeader\layHeader.vue
 * @Description: 顶部集成页
-->
<template>
    <div class="lay-header">
        <div class="lay-header-left">
            <img src="@/assets/svg/logo.svg" height="20">
        </div>
        <div class="lay-header-right">
            <!-- github -->
            <ATooltip>
                <template #title>{{ githubLink }}</template>
                <a :href="githubLink" target="_blank" rel="noopener noreferrer" class="icon-area">
                    <BaseSvg name="gl-icon-github" :size="24" color="var(--gl-color-text-level3)" />
                </a>
            </ATooltip>
            <!-- 问题指引 -->
            <ATooltip>
                <template #title>{{ helpLink }}</template>
                <a :href="helpLink" target="_blank" rel="noopener noreferrer" class="icon-area">
                    <BaseSvg name="gl-icon-help" :size="24" color="var(--gl-color-text-level3)" />
                </a>
            </ATooltip>
            <!-- Dark Mode Toggle -->
            <ATooltip>
                <template #title>{{ appStore.state.themeMode === ThemeMode.DARK ? 'Light Mode' : 'Dark Mode' }}</template>
                <a href="javascript:;" class="icon-area theme-toggle" @click="toggleTheme">
                    <unicon 
                        :name="appStore.state.themeMode === ThemeMode.DARK ? 'sun' : 'moon'" 
                        :fill="'var(--gl-color-text-level3)'"
                        :width="24"
                        :height="24"
                    />
                </a>
            </ATooltip>
            <!-- 竖线 -->
            <div class="vertical-line" />

            <a href="javascript:;" class="log-out" @click="userStore.manualLogout">
                <BaseSvg name="gl-icon-logout" style="margin-right: 12px;" :size="24" color="var(--gl-color-text-level3)"></BaseSvg>
                {{ $t('login.signOut') }}
            </a>
        </div>
    </div>
</template>

<script setup lang="ts">
import { useUserStore } from '@/stores/modules/user'
import { useAppStore } from '@/stores/modules/app'
import { ThemeMode } from 'gl-web-main'

const userStore = useUserStore()
const appStore = useAppStore()

// github链接
const githubLink = 'https://github.com/gl-inet/glkvm-cloud'

// 问题指引链接
const helpLink = 'https://www.gl-inet.com'

// Toggle between dark and light mode
const toggleTheme = () => {
    const newTheme = appStore.state.themeMode === ThemeMode.DARK ? ThemeMode.LIGHT : ThemeMode.DARK
    appStore.setThemeMode(newTheme)
}
</script>

<style scoped lang="scss">
.lay-header {
  width: 100%;
  height: 56px;
  line-height: 56px;
  border-bottom: 1px solid var(--gl-color-line-divider1);

  display: flex;
  justify-content: space-between;
  align-items: center;

  padding: 8px 20px;

  .lay-header-left {
    height: 100%;

    display: flex;
    align-items: center;
  }

  .lay-header-right {
    height: 100%;

    display: flex;
    align-items: center;

    .icon-area {
      width: 36px;
      height: 36px;
      display: flex;
      justify-content: center;
      align-items: center;
      border-radius: 4px;
      color: var(--gl-color-text-level3);
      cursor: pointer;

      &:hover {
        background-color: var(--gl-color-bg-icon-button-hover);
      }
    }

    .vertical-line {
      width: 1px;
      height: 24px;
      background-color: var(--gl-color-line-divider1);
      margin: 0 12px;
    }

    .log-out {
      display: flex;
      align-items: center;
      color: var(--gl-color-text-level3);
    }

  }
}
</style>