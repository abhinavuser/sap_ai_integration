package com.developer.nefarious.zjoule.test.memory;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.eclipse.core.runtime.preferences.IEclipsePreferences;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;
import org.osgi.service.prefs.BackingStoreException;

import com.developer.nefarious.zjoule.plugin.memory.EclipseMemory;

public class EclipseMemoryTest {

	private EclipseMemory cut;

	@Mock
	private IEclipsePreferences mockPreferences;

	@BeforeEach
	public void setUp() {
		MockitoAnnotations.openMocks(this);
		try (MockedStatic<EclipseMemory> eclipseMemoryStatic = mockStatic(EclipseMemory.class)) {
			eclipseMemoryStatic.when(() -> EclipseMemory.getEclipsePreferences()).thenReturn(mockPreferences);
			cut = new EclipseMemory();
		}
	}

	@Test
	public void shouldClearAllMemory() throws BackingStoreException {
		// Arrange
		// Act
		cut.clearAll();
		// Assert
		verify(mockPreferences).clear();
		verify(mockPreferences).flush();
	}

	@Test
	public void shouldDeleteFromEclipsePreferences() throws BackingStoreException {
		// Arrange
		String mockKey = "some key";
		// Act
		cut.deleteFromEclipsePreferences(mockKey);
		// Assert
		verify(mockPreferences).remove(mockKey);
		verify(mockPreferences).flush();
	}

	@Test
	public void shouldDoNothingIfClearFail() throws BackingStoreException {
		// Arrange
		doThrow(new BackingStoreException("Accidents happen")).when(mockPreferences).clear();
		// Act
		cut.clearAll();
		// Assert
		assertThrows(BackingStoreException.class, () -> mockPreferences.clear());
		verify(mockPreferences, never()).flush();
	}

	@Test
	public void shouldDoNothingInCaseOfErrorsOnDelete() throws BackingStoreException {
		// Arrange
		String mockKey = "some key";
		doThrow(new BackingStoreException("Accidents happen")).when(mockPreferences).flush();
		// Act
		cut.deleteFromEclipsePreferences(mockKey);
		// Assert
		verify(mockPreferences).remove(mockKey);
		assertThrows(BackingStoreException.class, () -> mockPreferences.flush());
	}

	@Test
	public void shouldDoNothingInCaseOfErrorsOnSave() throws BackingStoreException {
		// Arrange
		String mockKey = "some key";
		String mockValue = "some random value";
		doThrow(new BackingStoreException("Accidents happen")).when(mockPreferences).flush();
		// Act
		cut.saveOnEclipsePreferences(mockKey, mockValue);
		// Assert
		verify(mockPreferences).put(mockKey, mockValue);
		assertThrows(BackingStoreException.class, () -> mockPreferences.flush());
	}

	@Test
	public void shouldLoadValueFromKeyAndReturnNullIfItDoesntExist() {
		// Arrange
		String mockKey = "some key";
		String expectedValue = "some random value";
		when(mockPreferences.get(mockKey, null)).thenReturn(expectedValue);
		// Act
		String returnValue = cut.loadFromEclipsePreferences(mockKey);
		// Assert
		assertEquals(returnValue, expectedValue);
	}

	@Test
	public void shouldSaveOnEclipsePreferences() throws BackingStoreException {
		// Arrange
		String mockKey = "some key";
		String mockValue = "some random value";
		// Act
		cut.saveOnEclipsePreferences(mockKey, mockValue);
		// Assert
		verify(mockPreferences).put(mockKey, mockValue);
		verify(mockPreferences).flush();
	}

}
