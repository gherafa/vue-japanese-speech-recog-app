<template>
  <div class="relative w-64">
    <p class="mb-2 text-xl font-semibold text-white text-center">Select Level</p>
    <button
      @click="toggleDropdown"
      class="w-full flex justify-between items-center px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:border-blue-500 transition"
    >
      <span>{{ selectedLevel }}</span>
      <svg
        class="w-5 h-5 text-gray-500 transform transition-transform duration-200"
        :class="{'rotate-180': isOpen}"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
      </svg>
    </button>

    <div
      v-if="isOpen"
      class="absolute mt-1 w-full bg-white border border-gray-300 rounded-lg shadow-lg z-10"
    >
      <ul class="divide-y divide-gray-200">
        <li
          v-for="level in levels"
          :key="level"
          @click="selectLevel(level)"
          class="px-4 py-2 hover:bg-blue-100 cursor-pointer transition"
        >
          {{ level }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
const levels = ['basic', 'intermediate', 'advanced']

const props = defineProps({
  selectLevel: Function,
  selectedLevel: String,
  toggleDropdown: Function,
  isOpen: Boolean
})
</script>
