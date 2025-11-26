<template>
  <div class="flex justify-between items-center mx-2 px-4 py-2 border rounded-lg bg-white shadow">
    <button
      @click="handleClick"
      class="px-8 py-2 bg-blue-600 text-white text-sm rounded-lg shadow hover:bg-blue-700 active:scale-95 transition"
    >
      {{ isReveal ? 'Hide' : `Show ${section}` }}
    </button>

    <p class="text-gray-800 text-lg break-words text-justify px-3">
      <template v-if="isReveal">
        {{ props.value }}
      </template>
      <template v-else>
        <span class="inline-block w-40 h-5 bg-gray-200 rounded"></span>
      </template>
      </p>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  value: String,
  section: String
})

const isReveal = ref(false)

function handleClick() {
  isReveal.value = !isReveal.value
}
</script>
